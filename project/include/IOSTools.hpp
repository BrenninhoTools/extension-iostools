#ifndef IOSTOOLS_HPP
#define IOSTOOLS_HPP

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <string.h>
#include "iostools.h"

namespace iostools
{
	inline ::String take(char *ptr)
	{
		if (!ptr)
			return ::String::create("", 0);

		::String result = ::String::create(ptr, (int)strlen(ptr));
		iostools_free(ptr);
		return result;
	}

	inline void setEventCallback(::cpp::Function<void(const char *)> callback)
	{
		iostools_set_event_callback(callback.call);
	}
}

#endif
