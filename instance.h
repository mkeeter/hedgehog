#include "platform.h"

struct loader_;
struct camera_;
struct model_;
struct backdrop_;

typedef struct instance_ {
    struct backdrop_* backdrop;
    struct camera_* camera;
    struct loader_* loader;
    struct model_*  model;

    GLFWwindow* window;
} instance_t;

instance_t* instance_new(const char* filename);
void instance_run(instance_t* instance);

/*  Callbacks */
void instance_cb_window_size(instance_t* instance, int width, int height);
void instance_cb_keypress(instance_t* instance, int key, int scancode, int action, int mods);
void instance_cb_mouse_pos(instance_t* instance, float xpos, float ypos);
void instance_cb_mouse_click(instance_t* instance, int button, int action, int mods);
void instance_cb_mouse_scroll(instance_t* instance, float xoffset, float yoffset);