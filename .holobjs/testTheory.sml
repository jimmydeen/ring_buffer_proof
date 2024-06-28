structure testTheory :> testTheory =
struct
  
  val _ = if !Globals.print_thy_loads
    then TextIO.print "Loading testTheory ... "
    else ()
  
  open Type Term Thm
  local open panPtreeConversionTheory panSemTheory in end;
  
  structure TDB = struct
    val thydata = 
      TheoryReader.load_thydata "test"
        (holpathdb.subst_pathvars "$(CAKEMLDIR)/pancake/ring_buffer/testTheory.dat")
    fun find s = HOLdict.find (thydata,s)
  end
  
  fun op bla _ = () val op bla = TDB.find "bla"
  
  
val _ = if !Globals.print_thy_loads then TextIO.print "done\n" else ()
val _ = Theory.load_complete "test"

val test_grammars = valOf (Parse.grammarDB {thyname = "test"})
end
