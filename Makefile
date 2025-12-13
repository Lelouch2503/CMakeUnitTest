build_without_errors:
	# cd build && cmake .. --graphviz=graph.dot && dot -Tpng graph.dot -o graphImage.png
		
	rm -rf build && mkdir build && mkdir -p build_result && cd build && cmake \
	-DENABLED_AS_ERRORS=OFF \
	-DUSE_CPM=OFF \
	-DUSE_CONAN=OFF \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_TOOLCHAIN_FILE=../external/vcpkg/scripts/buildsystems/vcpkg.cmake \
	.. && cmake --build . 2>&1 | tee ../build_result/build_log.txt

build_with_errors:
	# cd build && cmake .. --graphviz=graph.dot && dot -Tpng graph.dot -o graphImage.png
	mkdir -p build_result && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build . 2>&1 | tee ../build_result/build_log.txt

prepare:
	rm -rf build
	mkdir build
conan_d:
	rm -rf build
	mkdir build
	cd build && conan install .. -s build_type=Debug -s compiler.cppstd=17 --output-folder=. --build missing | tee ../build_result/build_log.txt

conan_r:
	rm -rf build
	mkdir build
	cd build && conan install .. -s build_type=Release -s compiler.cppstd=17 --output-folder=. --build missing | tee ../build_result/build_log.txt
