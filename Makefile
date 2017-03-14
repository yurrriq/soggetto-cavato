doc_root := $(shell stack path --local-doc-root)

docs: ${doc_root}
	@ rsync -vazP $</ $@
