open HolKernel Parse boolLib bossLib stringLib numLib intLib;
open preamble panPtreeConversionTheory;
open helperLib;
open panPtreeConversionTheory panSemTheory;

val _ = new_theory "test";

local
  val f =
    List.mapPartial
       (fn s => case remove_whitespace s of "" => NONE | x => SOME x) o
    String.tokens (fn c => c = #"\n")
in
  fun quote_to_strings q =
    f (Portable.quote_to_string (fn _ => raise General.Bind) q)
end
    
fun parse_pancake q =
  let
    val code = quote_to_strings q |> String.concatWith "\n" |> fromMLstring
  in
    EVAL “parse_funs_to_ast ^code”
  end

val ringbuf_ast = parse_pancake ‘
fun pnk_memcpy(1 dst, 1 src, 1 len) {
 var i = 0;
    var c = 0;
    while (i < len) {
        !ld8 c, (src + i);
1        !st8 (dst + i), c;
        i = i + 1;
    }
 return 0;
}
fun pnk_memset(1 src, 1 character, 1 n) {
    var p = src;
    var end = src + n;
    while (p < end) {
        !st8 p, character;
        p = p + 1;
    }
    return src;
}
fun pnk_atoi(1 str_addr) {
    var p = str_addr;
    while (true) {
        var c = ld8 p;
        var r1 = (c == 32); var r2 = (c == 9); var r3 = (c == 10); var r4 = (c == 13); var r5 = (c == 11); var r6 = (c == 12); var isspace = (r1 || r2 || r3 || r4 || r5 || r6);
        if (isspace) {
            p = p + 1;
        } else {
            break;
        }
    }
    var sign = 1;
    var c = ld8 p;
    if (c == 43) {
        p = p + 1;
    } else {
        if (c == 45) {
            sign = -1;
            p = p + 1;
        }
    }
    var result = 0;
    while (true) {
        c = ld8 p;
        var r1 = (c >= 48); var r2 = (c <= 57); var isdigit = (r1 && r2);
        if (isdigit) {
            var digit = c - 48;
            result = result * 10;
            result = result - digit;
            p = p + 1;
        } else {
            break;
        }
    }
    result = 0 - result;
    return sign * result;
}
fun net_enqueue_free(1 queue_handle, 2 buffer) {
    var queue = 0; !ldw queue, queue_handle; var tail = 0; !ldw tail, queue; var queue = 0; !ldw queue, queue_handle; var head = 0; !ldw head, queue + 8; var size = 0; !ldw size, queue_handle + 2 * 8; var full = (tail + 1 - head) == size;
    if (full) {
        return -1;
    }
    var size = 0; !ldw size, queue_handle + 2 * 8;
    var queue = 0; !ldw queue, queue_handle; var tail = 0; !ldw tail, queue;
    var pnk_modulo_mask = size - 1; var idx = tail & pnk_modulo_mask;
    var free = 0; !ldw free, queue_handle;
    var buff = free + 3 * 8 + idx * (2 * 8);
    !stw buff, (buffer.0);
    !stw buff + 8, (buffer.1);
    @THREAD_MEMORY_RELEASE(0,42,0,42);
    tail = tail + 1;
    var queue = 0; !ldw queue, queue_handle; !stw queue, tail;
    return 0;
}
fun net_enqueue_active(1 queue_handle, 2 buffer) {
    var queue = 0; !ldw queue, queue_handle + 8; var tail = 0; !ldw tail, queue; var queue = 0; !ldw queue, queue_handle + 8; var head = 0; !ldw head, queue + 8; var size = 0; !ldw size, queue_handle + 2 * 8; var full = (tail + 1 - head) == size;
    if (full) {
        return -1;
    }
    var size = 0; !ldw size, queue_handle + 2 * 8;
    var queue = 0; !ldw queue, queue_handle + 8; var tail = 0; !ldw tail, queue;
    var pnk_modulo_mask = size - 1; var idx = tail & pnk_modulo_mask;
    var active = 0; !ldw active, queue_handle + 8;
    var buff = active + 3 * 8 + idx * (2 * 8);
    !stw buff, (buffer.0);
    !stw buff + 8, (buffer.1);
    @THREAD_MEMORY_RELEASE(0,42,0,42);
    tail = tail + 1;
    var queue = 0; !ldw queue, queue_handle + 8; !stw queue, tail;
    return 0;
}
fun net_dequeue_free(1 queue_handle, 1 buffer_addr) {
    var queue = 0; !ldw queue, queue_handle; var tail = 0; !ldw tail, queue; var queue = 0; !ldw queue, queue_handle; var head = 0; !ldw head, queue + 8; var empty = (tail - head) == 0;
    if (empty) {
        return -1;
    }
    var size = 0; !ldw size, queue_handle + 2 * 8;
    var queue = 0; !ldw queue, queue_handle; var head = 0; !ldw head, queue + 8;
    var pnk_modulo_mask = size - 1; var idx = head & pnk_modulo_mask;
    var free = 0; !ldw free, queue_handle;
    var buff = free + 3 * 8 + idx * (2 * 8);
    var buf_v = 0;
    !ldw buf_v, buff;
    !stw buffer_addr, buf_v;
    !ldw buf_v, buff + 8;
    !stw buffer_addr + 8, buf_v;
    @THREAD_MEMORY_RELEASE(0,42,0,42);
    head = head + 1;
    var queue = 0; !ldw queue, queue_handle; !stw queue + 8, head;
    return 0;
}
fun net_dequeue_active(1 queue_handle, 1 buffer_addr) {
    var queue = 0; !ldw queue, queue_handle + 8; var tail = 0; !ldw tail, queue; var queue = 0; !ldw queue, queue_handle + 8; var head = 0; !ldw head, queue + 8; var empty = (tail - head) == 0;
    if (empty) {
        return -1;
    }
    var size = 0; !ldw size, queue_handle + 2 * 8;
    var queue = 0; !ldw queue, queue_handle + 8; var head = 0; !ldw head, queue + 8;
    var pnk_modulo_mask = size - 1; var idx = head & pnk_modulo_mask;
    var active = 0; !ldw active, queue_handle + 8;
    var buff = active + 3 * 8 + idx * (2 * 8);
    var buf_v = 0;
    !ldw buf_v, buff;
    !stw buffer_addr, buf_v;
    !ldw buf_v, buff + 8;
    !stw buffer_addr + 8, buf_v;
    @THREAD_MEMORY_RELEASE(0,42,0,42);
    head = head + 1;
    var queue = 0; !ldw queue, queue_handle + 8; !stw queue + 8, head;
    return 0;
}
fun net_buffers_init(1 queue_handle, 1 base_addr) {
    return 0;
}

’

val nb_ast = parse_pancake ‘
fun net_buffers_init(1 queue_handle, 1 base_addr) {
    return 0;
}                
             ’
val nb = nb_ast |> concl |> rhs 
             
    
val defs = 
  parse_pancake ‘
fun main() {
        return 3;
         }
  ’ |> INST_TYPE [alpha|->“:64”] |> concl |> rhs |> rand

val _ = export_theory();
