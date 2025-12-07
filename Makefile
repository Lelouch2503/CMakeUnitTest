build_without_errors:
	# cd build && cmake .. --graphviz=graph.dot && dot -Tpng graph.dot -o graphImage.png
	cd build && cmake -DENABLED_AS_ERRORS=OFF .. && cmake --build . 2>&1 | tee build_log.txt

build_with_errors:
	# cd build && cmake .. --graphviz=graph.dot && dot -Tpng graph.dot -o graphImage.png
	cd build && cmake .. && cmake --build . 2>&1 | tee build_log.txt

prepare:
	rm -rf build
	mkdir build

