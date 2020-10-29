#ifndef __COMMON_HPP
#define __COMMON_HPP

#include <memory>
#include <stdint.h>

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;

typedef int8_t s8;
typedef int16_t s16;
typedef int32_t s32;

template <typename T> using uptr = std::unique_ptr<T[]>;
template <typename T> using sptr = std::shared_ptr<T[]>;

#endif
