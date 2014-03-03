COFFEE := coffee
COFFEE_FLAGS := --compile --bare
STYLUS := stylus

# Setup file locations
SRC_DIR  := app
OUT_DIR  := target

# Glob all the coffee source
SRC := $(shell find app -name "*.coffee")
LIB := $(SRC:$(SRC_DIR)/%.coffee=$(OUT_DIR)/%.js)

# Web assets
WEB := web/modules.coffee $(shell find web -name "*.coffee")
STY := $(shell find stylesheets -name "*.styl")

ASSETS := public/js/app.js public/stylesheets/style.css

.PHONY: all clean rebuild

# Phony all target
all: target $(LIB) $(ASSETS)
	@-echo "Finished building cgcu"

# Make target folder if doesn't exist
target:
	@echo Making target dir
	@mkdir target
	@echo "*\n!.gitignore" > target/.gitignore

# Phony clean target
clean:
	@-echo "Cleaning *.js files"
	@-rm -f $(LIB)
	@-rm -f $(ASSETS)

# Phony rebuild target
rebuild: clean all

# Compile js assets
public/js/app.js: $(WEB)
	@-echo "Compiling web js asset $@"
	@$(COFFEE) -cj $@ $^

# Compile css assets
public/stylesheets/style.css: $(STY)
	@-echo "Compiling stylesheet asset $@"
	@$(STYLUS) -c -o public/stylesheets $^

# Rule for all other coffee files
$(OUT_DIR)/%.js: $(SRC_DIR)/%.coffee
	@-echo "  Compiling $@"
	@$(COFFEE) $(COFFEE_FLAGS) -o $(shell dirname $@) $^

