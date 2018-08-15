
#ifndef BADVPN_PROTOCOL_SPPROTO_H
#define BADVPN_PROTOCOL_SPPROTO_H

#include <stdint.h>
#include <limits.h>

#include <misc/debug.h>
#include <misc/balign.h>
#include <misc/packed.h>
#include <security/BHash.h>
#include <security/BEncryption.h>
#include <security/OTPCalculator.h>

#define SPPROTO_HASH_MODE_NONE 0
#define SPPROTO_ENCRYPTION_MODE_NONE 0
#define SPPROTO_OTP_MODE_NONE 0

/**
 * Stores security parameters for SPProto.
 */
struct spproto_security_params {
    /**
     * Hash mode.
     * Either SPPROTO_HASH_MODE_NONE for no hashes, or a valid bhash
     * hash mode.
     */
    int hash_mode;
    
    /**
     * Encryption mode.
     * Either SPPROTO_ENCRYPTION_MODE_NONE for no encryption, or a valid
     * {@link BEncryption} cipher.
     */
    int encryption_mode;
    
    /**
     * One-time password (OTP) mode.
     * Either SPPROTO_OTP_MODE_NONE for no OTPs, or a valid
     * {@link BEncryption} cipher.
     */
    int otp_mode;
    
    /**
     * If OTPs are used (otp_mode != SPPROTO_OTP_MODE_NONE), number of
     * OTPs generated from a single seed.
     */
    int otp_num;
};

#define SPPROTO_HAVE_HASH(_params) ((_params).hash_mode != SPPROTO_HASH_MODE_NONE)
#define SPPROTO_HASH_SIZE(_params) ( \
    SPPROTO_HAVE_HASH(_params) ? \
    BHash_size((_params).hash_mode) : \
    0 \
)

#define SPPROTO_HAVE_ENCRYPTION(_params) ((_params).encryption_mode != SPPROTO_ENCRYPTION_MODE_NONE)

#define SPPROTO_HAVE_OTP(_params) ((_params).otp_mode != SPPROTO_OTP_MODE_NONE)

B_START_PACKED
struct spproto_otpdata {
    uint16_t seed_id;
    otp_t otp;
} B_PACKED;
B_END_PACKED

#define SPPROTO_HEADER_OTPDATA_OFF(_params) 0
#define SPPROTO_HEADER_OTPDATA_LEN(_params) (SPPROTO_HAVE_OTP(_params) ? sizeof(struct spproto_otpdata) : 0)
#define SPPROTO_HEADER_HASH_OFF(_params) (SPPROTO_HEADER_OTPDATA_OFF(_params) + SPPROTO_HEADER_OTPDATA_LEN(_params))
#define SPPROTO_HEADER_HASH_LEN(_params) SPPROTO_HASH_SIZE(_params)
#define SPPROTO_HEADER_LEN(_params) (SPPROTO_HEADER_HASH_OFF(_params) + SPPROTO_HEADER_HASH_LEN(_params))

/**
 * Asserts that the given SPProto security parameters are valid.
 * 
 * @param params security parameters
 */
static void spproto_assert_security_params (struct spproto_security_params params)
{
    ASSERT(params.hash_mode == SPPROTO_HASH_MODE_NONE || BHash_type_valid(params.hash_mode))
    ASSERT(params.encryption_mode == SPPROTO_ENCRYPTION_MODE_NONE || BEncryption_cipher_valid(params.encryption_mode))
    ASSERT(params.otp_mode == SPPROTO_OTP_MODE_NONE || BEncryption_cipher_valid(params.otp_mode))
    ASSERT(params.otp_mode == SPPROTO_OTP_MODE_NONE || params.otp_num > 0)
}

/**
 * Calculates the maximum payload size for SPProto given the
 * security parameters and the maximum encoded packet size.
 * 
 * @param params security parameters
 * @param carrier_mtu maximum encoded packet size. Must be >=0.
 * @return maximum payload size. Negative means is is impossible
 *         to encode anything.
 */
static int spproto_payload_mtu_for_carrier_mtu (struct spproto_security_params params, int carrier_mtu)
{
    spproto_assert_security_params(params);
    ASSERT(carrier_mtu >= 0)
    
    if (params.encryption_mode == SPPROTO_ENCRYPTION_MODE_NONE) {
        return (carrier_mtu - SPPROTO_HEADER_LEN(params));
    } else {
        int block_size = BEncryption_cipher_block_size(params.encryption_mode);
        return (balign_down(carrier_mtu, block_size) - block_size - SPPROTO_HEADER_LEN(params) - 1);
    }
}

/**
 * Calculates the maximum encoded packet size for SPProto given the
 * security parameters and the maximum payload size.
 * 
 * @param params security parameters
 * @param payload_mtu maximum payload size. Must be >=0.
 * @return maximum encoded packet size, -1 if payload_mtu is too large
 */
static int spproto_carrier_mtu_for_payload_mtu (struct spproto_security_params params, int payload_mtu)
{
    spproto_assert_security_params(params);
    ASSERT(payload_mtu >= 0)
    
    if (params.encryption_mode == SPPROTO_ENCRYPTION_MODE_NONE) {
        if (payload_mtu > INT_MAX - SPPROTO_HEADER_LEN(params)) {
            return -1;
        }
        
        return (SPPROTO_HEADER_LEN(params) + payload_mtu);
    } else {
        int block_size = BEncryption_cipher_block_size(params.encryption_mode);
        
        if (payload_mtu > INT_MAX - (block_size + SPPROTO_HEADER_LEN(params) + block_size)) {
            return -1;
        }
        
        return (block_size + balign_up((SPPROTO_HEADER_LEN(params) + payload_mtu + 1), block_size));
    }
}

#endif
