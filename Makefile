all: stl doc

stl:
	./scripts/export.sh

doc:
	./scripts/list-models.sh | tee MODELS.md
