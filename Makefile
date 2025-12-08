build_without_errors:
	# cd build && cmake .. --graphviz=graph.dot && dot -Tpng graph.dot -o graphImage.png
	mkdir build_result && cd build && cmake -DENABLED_AS_ERRORS=OFF .. && cmake --build . 2>&1 | tee ../build_result/build_log.txt

build_with_errors:
	# cd build && cmake .. --graphviz=graph.dot && dot -Tpng graph.dot -o graphImage.png
	mkdir build_result && cd build && cmake .. && cmake --build . 2>&1 | tee ../build_result/build_log.txt

prepare:
	rm -rf build
	mkdir build
conan_d:
	rm -rf build
	mkdir build
	cd build && conan install .. -s build_type=Debug -s compiler.cppstd=17 --output-folder=. --build missing

conan_r:
	rm -rf build
	mkdir build
	cd build && conan install .. -s build_type=Release -s compiler.cppstd=17 --output-folder=. --build missing
