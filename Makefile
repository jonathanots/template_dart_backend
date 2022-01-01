run:
	dart example/main.dart

ifeq (module, $(firstword $(MAKECMDGOALS)))
  runargs := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
  $(eval $(runargs):;@true)
endif

help: 
	@echo "run 					- use this command to run the application source code" 
	@echo "module [--args] 			- use this command create module from some collection in MongoDatabse presetted on .env file" 

module: 
	dart lib/core/utils/extractor/extractor_module.dart $(runargs)