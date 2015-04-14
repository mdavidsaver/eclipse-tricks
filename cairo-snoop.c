#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

#include <cairo/cairo.h>

/*
 Can't just dlsym w/ RTLD_NEXT as libcairo
 is imported indirectly as a result of dlopen
 w/ RTLD_LOCAL, so this symbol can't found again.

 Instead import it again directly from libcairo,
 and hope its the same code...

 Build:
  gcc -o snoop.so -fPIC -fpic -shared -D_GNU_SOURCE -g -Wall cairo-snoop.c
 Run:
  LD_PRELOAD=/path/to/snoop.so ./cs-studio
*/

static void* getfn(const char *name)
{
  void *fn = NULL;
  void *key = dlopen("libcairo.so", RTLD_NOW|RTLD_LOCAL);
  if(key) {
    char *err;
    fn = dlsym(key, name);
    err = dlerror();
    if(err)
      fprintf(stderr, "dlsym: %s\n", err);
    else if(!fn)
      fprintf(stderr, "no error, no symbol\n");
    dlclose(key);
  } else {
    fprintf(stderr, "Failed to open libcairo\n");
  }
  return fn;
}

typedef void (*cairo_set_operator_t)(cairo_t *cr, cairo_operator_t op);

void
cairo_set_operator (cairo_t *cr, cairo_operator_t op)
{
  cairo_set_operator_t orig = (cairo_set_operator_t)getfn("cairo_set_operator");
  fprintf(stderr, "cairo_set_operator(%p, %d)\n", cr, op);
  if(!orig || !cr || orig==&cairo_set_operator) {
    fprintf(stderr, "  oops! %p %p\n", orig, cr);
    return;
  }
  (*orig)(cr, op);
}

typedef cairo_t * (*cairo_create_t)(cairo_surface_t *cr);

cairo_t *
cairo_create (cairo_surface_t *target)
{
  cairo_t *ret;
  cairo_create_t orig = (cairo_create_t)getfn("cairo_create");
  if(!orig || !target || orig==&cairo_create) {
    fprintf(stderr, "  oops! %p %p\n", orig, target);
    return NULL;
  }
  ret = (*orig)(target);
  fprintf(stderr, "cairo_create(%p) = %p\n", target, ret);
  return ret;
}

typedef void (*cairo_destroy_t)(cairo_t *cr);

void
cairo_destroy (cairo_t *cr)
{
  cairo_destroy_t orig = (cairo_destroy_t)getfn("cairo_destroy");
  fprintf(stderr, "cairo_destroy(%p)\n", cr);
  if(!orig || !cr || orig==&cairo_destroy) {
    fprintf(stderr, "  oops! %p %p\n", orig, cr);
    return;
  }
  (*orig)(cr);
}
