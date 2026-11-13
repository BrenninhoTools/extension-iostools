#ifndef IOSTOOLS_H
#define IOSTOOLS_H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef void (*iostools_event_callback)(const char *payload);

void iostools_set_event_callback(iostools_event_callback callback);
void iostools_free(char *ptr);

char *iostools_device_name(void);
char *iostools_device_model(void);
char *iostools_device_localized_model(void);
char *iostools_device_machine(void);
char *iostools_device_system_name(void);
char *iostools_device_system_version(void);
char *iostools_device_identifier_for_vendor(void);
char *iostools_device_language(void);
char *iostools_device_locale(void);
char *iostools_device_region(void);
char *iostools_device_timezone(void);
int iostools_device_idiom(void);
int iostools_device_orientation(void);
double iostools_device_battery_level(void);
int iostools_device_battery_state(void);
bool iostools_device_low_power_mode(void);
int iostools_device_thermal_state(void);
double iostools_device_physical_memory(void);
int iostools_device_processor_count(void);
int iostools_device_active_processor_count(void);
double iostools_device_system_uptime(void);
bool iostools_device_is_simulator(void);
bool iostools_device_is_ios_app_on_mac(void);
bool iostools_device_is_version_at_least(int major, int minor, int patch);
void iostools_device_start_monitoring(void);
void iostools_device_stop_monitoring(void);

char *iostools_app_bundle_id(void);
char *iostools_app_version(void);
char *iostools_app_build(void);
char *iostools_app_display_name(void);
int iostools_app_state(void);
bool iostools_app_open_url(const char *url);
bool iostools_app_can_open_url(const char *url);
bool iostools_app_open_settings(void);
void iostools_app_request_review(void);
void iostools_app_set_badge(int count);
int iostools_app_get_badge(void);

char *iostools_paths_documents(void);
char *iostools_paths_library(void);
char *iostools_paths_caches(void);
char *iostools_paths_application_support(void);
char *iostools_paths_temporary(void);
char *iostools_paths_bundle(void);
double iostools_paths_free_space(void);
double iostools_paths_total_space(void);
bool iostools_paths_exclude_from_backup(const char *path, bool exclude);

double iostools_screen_get_brightness(void);
void iostools_screen_set_brightness(double value);
bool iostools_screen_get_keep_awake(void);
void iostools_screen_set_keep_awake(bool value);
double iostools_screen_scale(void);
double iostools_screen_native_scale(void);
double iostools_screen_width(void);
double iostools_screen_height(void);
double iostools_screen_native_width(void);
double iostools_screen_native_height(void);
double iostools_screen_safe_area_top(void);
double iostools_screen_safe_area_left(void);
double iostools_screen_safe_area_bottom(void);
double iostools_screen_safe_area_right(void);
int iostools_screen_max_fps(void);
bool iostools_screen_is_captured(void);

bool iostools_haptic_supported(void);
void iostools_haptic_impact(int style, double intensity);
void iostools_haptic_notification(int type);
void iostools_haptic_selection(void);
void iostools_haptic_vibrate(void);

void iostools_alert_show(int requestId, const char *title, const char *message, const char *buttons, int style, int cancelIndex, int destructiveIndex);
void iostools_alert_prompt(int requestId, const char *title, const char *message, const char *placeholder, const char *text, const char *confirm, const char *cancel, bool secure);
void iostools_toast_show(const char *message, double duration);

void iostools_clipboard_set_text(const char *text);
char *iostools_clipboard_get_text(void);
bool iostools_clipboard_has_text(void);
void iostools_clipboard_clear(void);

void iostools_share(int requestId, const char *text, const char *url, const char *files);

int iostools_permission_status(int type);
void iostools_permission_request(int requestId, int type);

void iostools_notifications_schedule(const char *identifier, const char *title, const char *body, double seconds, bool repeats, int badge, bool sound);
void iostools_notifications_cancel(const char *identifier);
void iostools_notifications_cancel_all(void);
void iostools_notifications_clear_delivered(void);
void iostools_notifications_set_foreground_presentation(bool enabled);

void iostools_network_start(void);
void iostools_network_stop(void);
bool iostools_network_is_connected(void);
int iostools_network_type(void);
bool iostools_network_is_expensive(void);
bool iostools_network_is_constrained(void);

bool iostools_audio_set_category(int category, bool mixWithOthers);
bool iostools_audio_set_active(bool active);
bool iostools_audio_other_audio_playing(void);
double iostools_audio_output_volume(void);
bool iostools_audio_headphones_connected(void);
void iostools_audio_start_monitoring(void);

#ifdef __cplusplus
}
#endif

#endif
