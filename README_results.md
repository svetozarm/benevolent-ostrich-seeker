# SPECCPU2006 results

## Contents

Each of the result directories contains the following:

1. Map files

The function, source, type and variable maps for decyphering the logs. These will map integer IDs to string names for each element.

2. code.txt

This file contains snippets around each of the allocation points. The format is:
> <file_id>_<line_id>_<col_id> filename
> 
> Code, with the actual line prefixed with three asterisks (***)

3. output.log

The piped output of the SPEC benchmark execution

4. extracted/

Directory containing the traces. Traces are prefixed with the allocation point coordinates, and suffixed with _access.txt (for timestamped accesses), and _invariants.json (for line-by-line json dump of all the invariant fields associated to each allocated region)
The format of the access traces contains three entries:
+ timestamp - global timestamp of the event
+ allocation base - the base address of the accessed memory region
+ offset - offset of the accessed field (to be able to convert the trace into actual addresses, if needed)


