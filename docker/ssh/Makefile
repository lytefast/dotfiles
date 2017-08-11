
clean-ssh:
	rm -rf .ssh

clean-docker:
	docker rmi lytefast/ssh

clean:
	$(MAKE) clean-ssh clean-docker

build:
	cp -r ~/.ssh .
	docker build -t lytefast/ssh .
	$(MAKE) clean-ssh
