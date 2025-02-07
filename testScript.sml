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

val defs = 
  parse_pancake ‘
fun main() {
        return 3;
         }
  ’ |> INST_TYPE [alpha|->“:64”] |> concl |> rhs |> rand

Theorem bla:
  0 < s.clock ⇒
  ∃x s'. evaluate (TailCall (Label $ strlit "main") [],
                   s with code := FEMPTY |++ ^defs
                  ) =
         (SOME(Return(ValWord x)), s') ∧ x ≠ 2w
Proof
  rw[Once evaluate_def] >>
  rw[eval_def,FLOOKUP_FUPDATE_LIST,lookup_code_def] >>
  rw[Once evaluate_def] >>
  rw[eval_def,
     shape_of_def,
     panLangTheory.size_of_shape_def
    ]
QED
  
val _ = export_theory();
