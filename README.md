# Kitchen::Poolsclosed

![](http://i.imgur.com/QnCGPzK.png)

[test-kitchen](www.kitchen.ci) Plugin for [poolsclosed](www.github.com/chrisevett/poolsclosed)


## Installation

    $ gem install kitchen-poolsclosed

## .kitchen.yml config
	  driver:  
	    name: poolsclosed  
	    poolsclosed_baseurl: http://path.tomy.rundeck.com/  
	
	  transport:  
	    name: winrm  
	    username: administrator  
	    password: mysupersecretpassword  

Note: this currently only supports windows. Yes the bit that touches the operating system is independent of this driver. Don't ask questions. 

## Contributing

Pull requests welcome [https://github.com/chrisevett/kitchen-poolsclosed](https://github.com/chrisevett/kitchen-poolsclosed)

