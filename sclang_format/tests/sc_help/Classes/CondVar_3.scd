// Source: Classes/CondVar.schelp block 3
(
var full = CondVar(), empty = CondVar();
var queue = Array();
var counter = 0; // The task counter is shared among all producers this time

// Try experimenting with these parameters
var maxQueueSize = 10;
var numProducers = 3;
var numConsumers = 3;
var producerWaitTimeRange = [0.3, 1.5];
var consumerWaitTimeRange = [0.3, 1.5];

// producer threads
numProducers.do { |index|
	fork {
		var task;
		loop {
			full.wait({ queue.size < maxQueueSize });

			task = counter;
			counter = counter + 1;
			queue = queue.add(task);
			postf("Producer % created a task: %. Current queue size: %\n",
				index, task, queue.size);

			// Even though there might be multiple consumers waiting
			// on this condition, only one of them can possibly make
			// use of the new task we just created.  So we use
			// signalOne instead of signalAll.
			empty.signalOne;

			wait(rrand(producerWaitTimeRange[0], producerWaitTimeRange[1]));
		}
	}
};

// consumer thread
numConsumers.do { |index|
	fork {
		var task;
		loop {
			empty.wait({ queue.notEmpty });

			task = queue.removeAt(0);
			postf("Consumer % processed a task: %. Current queue size: %\n",
				index, task, queue.size);

			full.signalOne;

			wait(rrand(consumerWaitTimeRange[0], consumerWaitTimeRange[1]));
		}
	}
}
)
