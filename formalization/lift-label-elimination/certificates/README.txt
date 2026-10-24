GENERATED CERTIFICATE COMPONENTS

These are the literal output fragments of the normal-form and row-connection
generators. They are assembled, unchanged except for their import headers, into
the ten root-level *Certificates*.lean modules. Those assembled modules are the
actual compiled Lean sources. The fragments are not independent library modules;
their historical import names identify the corresponding certificate namespaces.

certificate-assembly.json maps every fragment and hash to its compiled module.
check_generators.py regenerates the fragments and assembled sources in an
isolated directory and compares every hash. AuditAll.lean queries the axioms of
all their named declarations in the compiled assembled modules. No additional
axiom or separate native-decision checker is used for these certificates.
