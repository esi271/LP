# Exam of Programming Languages

**27 November 2024**

**Disclaimer.** Note that to have a running solution for an exercise is not enough: you need a well-cooked solution that proves your ability to use what explained during the classes. All the exercises have the same value: 11; Exercise are valued separately and it is necessary to get at least 6 points each exercise to pass the exams, i.e., 18 achieved with only 2 exercises means to fail the exam.

## Exercise Erlang: Distributed Sleep Sort

Some years ago has circulated an innovative approach to sorting named sleep sort that promises linear time complexity. Such an approach rely on the **sleep** system call to sort the numbers: each number is dealt as a thread which is suspended as many milliseconds as the number itself and when resumed it will just print (or return) its number. The scheduler will play the magic by resuming the threads in the correct order.

The following is the shell script implementation:

```bash
#!/bin/bash
function f() {
   sleep "$1"
   echo "$1"
}
while [ -n "$1" ]
do
   f "$1" &
   shift
done
wait
```

The approach suffers of several issues: it doesn't work with negative numbers and it takes eons to sort large numbers, just to cite a few. But the idea is interesting and it is a good exercise to be realized in different languages, as python, java or erlang.

The exercise consists of coding the sleep sort algorithm as an erlang function `sleepsort/1` that gets the numbers to be sorted and spawns several actors according to the presented algorithm. The actors will be spawned on separate erlang nodes, named `sleep01`, ..., `sleep`<sub>n</sub>, where n is the length of the set to be sorted. Each stage of the algorithm will print on its node the message `"I'm the stage n"` (n is the number it represents) when it is started and the message `"I waited n milliseconds"` just before returning its value to the master process that collects them in a sorted list. To render the exercise more appealing implement the sleepsort as a remote service, started by the `start/0` that can receive two kind of messages:

1. a list to sort, and
2. a message to stop its execution.

All the server-side functions are implemented in the `sleepsort` module.

The client should implement a `queries/1` function which queries the service and waits (blocked) the results and prints them once received. This function is also used to send a quit message to the sleepsort actor that will stop the whole server. The client will be notified that the server has stopped and it will write out the message `"service stopped!"` The client should also implement a function `connect_server/1` that receives the **name** of the node running the sleepsort server to be used by client process. All the client-side functionality must be implemented in the `client` module.

**For the sake of the exercise**, you can order a maximum of 29 numbers so the total numbers of the erlang nodes to be spawned is 30 (the node sleepsort and its 29 stages) plus the node running the client requests.

The following is an example of the expected behavior. In the blueish frame you have the queries of the client. The black image, shows how the sleepsort actor and its 29 stages behave when dealing the queries in the blueish frame.

### Client (blueish frame)

> ⚠️ Le righe lunghe sono tagliate a destra nella foto: riportate fin dove si legge.

```
[17:55:58]cazzola@jarnbjorn:~/lp/erlang> erl -sname client
(client@jarnbjorn)2> client:connect_server(sleepsort@jarnbjorn).
We are connected to the server.
(client@jarnbjorn)3> client:queries([5,1,0,1000,100, 90, 102, 33, 25, 7, 8, 99, 23, 99, 34, 11, 250]).
[5,1,0,1000,100,90,102,33,25,7,8,99,23,99,34,11,250] :- [5,1,0,1000,100,90,102,33,25,7,8,99,23, ...
(client@jarnbjorn)4> client:queries([5000,4000,3000,2000,1000,900,800,700,600,500,400,300,200, ...
[5000,4000,3000,2000,1000,900,800,700,600,500,400,300,200,100,90,80,70,60,50,40,30,20,10,9,8,7, ...
(client@jarnbjorn)5> client:queries(quit).
service stopped!
```

### Server and stages (black image)

Un terminale per nodo: `sleepsort` più `sleep01` … `sleep29`. Per ogni stage compaiono le due query (la prima lista, poi la seconda).

```
(sleepsort@jarnbjorn)1> sleepsort:start().
yes
sleepsort service finished!
(sleepsort@jarnbjorn)2>
```

| Nodo | Query 1 | Query 2 |
|---|---|---|
| `sleep01@jarnbjorn` | stage 5, waited 5 millisecs | stage 5000, waited 5000 millisecs |
| `sleep02@jarnbjorn` | stage 1, waited 1 | stage 4000, waited 4000 |
| `sleep03@jarnbjorn` | stage 0, waited 0 | stage 3000, waited 3000 |
| `sleep04@jarnbjorn` | stage 1000, waited 1000 | stage 2000, waited 2000 |
| `sleep05@jarnbjorn` | stage 100, waited 100 | stage 1000, waited 1000 |
| `sleep06@jarnbjorn` | stage 90, waited 90 | stage 900, waited 900 |
| `sleep07@jarnbjorn` | stage 102, waited 102 | stage 800, waited 800 |
| `sleep08@jarnbjorn` | stage 33, waited 33 | stage 700, waited 700 |
| `sleep09@jarnbjorn` | stage 25, waited 25 | stage 600, waited 600 |
| `sleep10@jarnbjorn` | stage 7, waited 7 | stage 500, waited 500 |
| `sleep11@jarnbjorn` | stage 8, waited 8 | stage 400, waited 400 |
| `sleep12@jarnbjorn` | stage 99, waited 99 | stage 300, waited 300 |
| `sleep13@jarnbjorn` | stage 23, waited 23 | stage 200, waited 200 |
| `sleep14@jarnbjorn` | stage 99, waited 99 | stage 100, waited 100 |
| `sleep15@jarnbjorn` | stage 34, waited 34 | stage 90, waited 90 |
| `sleep16@jarnbjorn` | stage 11, waited 11 | stage 80, waited 80 |
| `sleep17@jarnbjorn` | stage 250, waited 250 | stage 70, waited 70 |
| `sleep18@jarnbjorn` | – | stage 60, waited 60 |
| `sleep19@jarnbjorn` | – | stage 50, waited 50 |
| `sleep20@jarnbjorn` | – | stage 40, waited 40 |
| `sleep21@jarnbjorn` | – | stage 30, waited 30 |
| `sleep22@jarnbjorn` | – | stage 20, waited 20 |
| `sleep23@jarnbjorn` | – | stage 10, waited 10 |
| `sleep24@jarnbjorn` | – | stage 9, waited 9 |
| `sleep25@jarnbjorn` | – | stage 8, waited 8 |
| `sleep26@jarnbjorn` | – | stage 7, waited 7 |
| `sleep27@jarnbjorn` | – | stage 6, waited 6 |
| `sleep28@jarnbjorn` | – | stage 5, waited 5 |
| `sleep29@jarnbjorn` | – | stage 4, waited 4 |

Formato dei messaggi stampati da ogni stage (esempio da `sleep01`):

```
(sleep01@jarnbjorn)1> I'm the stage 5
I waited 5 millisecs
I'm the stage 5000
I waited 5000 millisecs
```

**All the solutions not conform to the specification will be considered wrong.**
