#ifndef __TYPE
#define __TYPE

#include "nspc.h"
#include "env.h"

struct Type_ {
  m_uint    xid;
  m_uint    size;
  m_str     name;
  Nspc      nspc;
  Type      parent;
  Nspc      owner;
  m_uint    array_depth;
  Class_Def def;
  union type_data {
    Func      func;
    Type      base_type;
  } d;
  struct pool* p;
  ae_flag flag;
  HAS_OBJ
};

Type t_void, t_int, t_float, t_dur, t_time, t_now, t_complex, t_polar, t_vec3, t_vec4,
  t_null, t_object, t_shred, t_event, t_ugen, t_string, t_ptr, t_array, t_gack,
  t_function, t_fptr, t_vararg, t_class, t_union;

ANN m_bool type_engine_check_prog(const Env, const Ast, const m_str);
ANN2(2) ANEW Type new_type(const m_uint xid, const m_str name, const Type);
ANEW ANN Type type_copy(const Type type);
ANN Env type_engine_init(VM*, const Vector) __attribute__((malloc));
ANN Value find_value(const Type, const Symbol);
ANN Func find_func(const Type, const Symbol);
ANN Type find_type(const Env, ID_List);
ANN m_bool isa(const Type, const Type) __attribute__((pure));
ANN m_bool isres(const Symbol);
ANN Type array_type(const Type, const m_uint);
ANN m_bool check_array_empty(const Array_Sub, const int);
ANN Type find_common_anc(const Type, const Type) __attribute__((pure));
ANN m_uint id_list_len(ID_List);
ANN void type_path(const m_str, const ID_List);
m_uint num_digit(const m_uint) __attribute__((pure));
ANN Type array_base(Type) __attribute__((pure));
ANN m_bool type_ref(Type) __attribute__((pure));
ANN m_bool prim_ref(const Type_Decl*, const Type);
ANN m_bool already_defined(const Env env, const Symbol s, const int pos);
static inline Type actual_type(const Type t) {
  return isa(t, t_class) > 0 ? t->d.base_type : t;
}
#endif

