tvm-devel:
	docker build -t tvm-devel .

run:
	docker run -it tvm-devel bash

clean-images:
	docker rm $(docker ps -a -q)
