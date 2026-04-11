// Source: Classes/CondVar.schelp block 2
(
var full = CondVar(), empty = CondVar();
var queue = Array();
var maxQueueSize = 5;
// The producer and consumer will wait between tasks for a duration
// somewhere in these ranges.  Over time, you'll see the queue grow
// and shrink between 0 and maxQueueSize, but CondVar keeps everything
// synchronized.
var producerWaitTimeRange = [0.1, 1];
var consumerWaitTimeRange = [0.1, 1];

// The "wait"s in each thread simulate doing some task asynchronously,
// during which time other tasks might be created. If our tasks were
// always created and/or executed synchronously, there would be no
// need for a queue shared between two threads.

// producer thread
fork {
	var counter = 0; // Our "task" is just an increasing number for now
	var task;
	loop {
		// This guarantees that when we return from `wait`, there is
		// enough room in the queue to add another task. To get past
		// this, we have to wait until the consumer calls
		// signalOne.
		full.wait({ queue.size < maxQueueSize });

		task = counter;
		counter = counter + 1;
		queue = queue.add(task);
		postf("Producer created a task: %. Current queue size: %\n",
			task, queue.size);

		// Now that we've added a task to the queue, we have to let
		// the consumer thread know in case it was waiting on us.
		empty.signalOne;

		wait(rrand(producerWaitTimeRange[0], producerWaitTimeRange[1]));
	}
};

// consumer thread
fork {
	var task;
	loop {
		// As in the producer thread, this blocks us until both the
		// queue has something in it, and we've been signaled by the
		// producer.
		empty.wait({ queue.notEmpty });

		task = queue.removeAt(0);
		postf("Consumer processed a task: %. Current queue size: %\n",
			task, queue.size);

		// We need to signal to the producer, in case it was waiting
		// on us to insert something into the queue.
		full.signalOne;

		wait(rrand(consumerWaitTimeRange[0], consumerWaitTimeRange[1]));
	}
};
)
