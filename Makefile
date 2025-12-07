dependency:
	# cd build && cmake .. --graphviz=graph.dot && dot -Tpng graph.dot -o graphImage.png
	cd build && cmake .. && cmake --build .
prepare:
	rm -rf build
	mkdir build
