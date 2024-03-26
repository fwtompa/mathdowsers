all:
	echo "must make one of corpus, index, or query"

corpus:
	$(MAKE) -C src corpus

index:
	$(MAKE) -C src index

query:
	$(MAKE) -C src query

