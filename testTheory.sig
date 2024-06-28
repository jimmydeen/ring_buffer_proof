signature testTheory =
sig
  type thm = Thm.thm
  
  (*  Theorems  *)
    val bla : thm
  
  val test_grammars : type_grammar.grammar * term_grammar.grammar
(*
   [panPtreeConversion] Parent theory of "test"
   
   [panSem] Parent theory of "test"
   
   [bla]  Theorem
      
      ⊢ 0 < s.clock ⇒
        ∃x s'.
          evaluate
            (TailCall (Label «main») [],
             s with code := FEMPTY |++ [(«main»,[],Return (Const 3w))]) =
          (SOME (Return (ValWord x)),s') ∧ x ≠ 2w
   
   
*)
end
