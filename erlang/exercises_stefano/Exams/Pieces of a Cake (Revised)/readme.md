**Disclaimer.** Note that to have a running solution for an exercise is not enough: you need a well-cooked solution that proves your ability to use what explained during the classes. All the exercises have the same value: 11; Exercise are valued separately and it is necessary to get at least 6 points each exercise to pass the exams, i.e., 18 achieved with only 2 exercises means to fail the exam.

# Exercise Erlang: Pieces of a Cake (Revised)

To share a secret over the Internet is a really tough task since any communication can be eavesdropped. Typically approaches to the problem are based on encryption but this not solves the problems just delays it, i.e., smugglers can stole your encrypted data and crack they down later. Another approach consists in splitting the data, shuffling the pieces and sending each of them through a different way and let the receiver to reconstruct the original message. Basically each piece of data is useless in isolation and potentially difficult to stole all the pieces in order to rebuild the original data.

The exercise consists of simulating this behavior in Erlang, through three modules `sender`, `receiver` and `switch`.

The `sender` module will take care of splitting the data (in our simulation a string that must be tokenized on the white spaces) and of forwarding each token to the `receiver` via a different `switch` process. The `receiver`, defined into the `receiver` module, has to collect *all* the pieces, reorder them and join them into the original string. Note that, the receiver does not know the number of pieces that compose a message and they are sent to the receiver in a random order. The `switch` module must define the switch processes; they are spawned by the sender and run on the same virtual machine as the sender (note that the receiver is on a different virtual machine).

The `sender` module must define a `start/2` function that initializes the sender; it takes the number of switches to be spawned (if the message is split in more token than the spawned switched reuse them) and the atom describing the remote node where the receiver is run. Analogously the `receiver` module must define a `start/0` function to initializes the receiver as well. **Hint** register the sender and receiver with an homonymous label.

The `sender` module must also define

- `send_msg/1` to send a message to the sender and therefore begin the distribution process,
- `quit/0` to gracely stop the sender actor and all its switches, and
- `shutdown/0` to gracely shutdown the whole system, receiver included.

**Note** that the REPL is not the sender actor nor the receiver actor.

The following traces show respectively the protocol followed by the sender and by the receiver and the expected results. The printed messages are those expected by a correct solution.

## Trace (sender)

> La traccia è tagliata in fondo alla foto: mancano le righe successive.

```
[21:58]cazzola@jarnbjorn:~/lp/erlang>erl -sname amora
(amora@jarnbjorn)1> sender:start(7, sif@jarnbjorn).
(amora@jarnbjorn)2> sender:send_msg("Sopra la panca la capra canta!!! Sotto la panca la capra crepa!!!").
The switch #1 is initializing the communication process
The switch #2 is routing the message "Sopra"
The switch #3 is routing the message "la"
The switch #4 is routing the message "panca"
The switch #5 is routing the message "la"
The switch #6 is routing the message "capra"
The switch #7 is routing the message "canta!!!"
The switch #1 is routing the message "Sotto"
The switch #2 is routing the message "la"
The switch #3 is routing the message "panca"
The switch #4 is routing the message "la"
The switch #5 is routing the message "capra"
The switch #6 is routing the message "crepa!!!"
The switch #7 is finishing the communication process
(amora@jarnbjorn)3> sender:quit().
I'm closing ...
The switch #1 is gracely exiting
The switch #3 is gracely exiting
The switch #5 is gracely exiting
The switch #7 is gracely exiting
The switch #6 is gracely exiting
The switch #4 is gracely exiting
The switch #2 is gracely exiting
(amora@jarnbjorn)4> sender:start(20, sif@jarnbjorn).
(amora@jarnbjorn)5> sender:send_msg("Trentatre Trentini entrarono a Trento tutti e trentatre tro...
The switch #1 is initializing the communication process
The switch #2 is routing the message "Trentatre"
The switch #3 is routing the message "Trentini"
The switch #4 is routing the message "entrarono"
The switch #5 is routing the message "a"
The switch #6 is routing the message "Trento"
The switch #7 is routing the message "tutti"
The switch #8 is routing the message "e"
The switch #9 is routing the message "trentatre"
The switch #10 is routing the message "trotterellando!"
The switch #11 is finishing the communication process
(amora@jarnbjorn)6> sender:send_msg("Apelle, figlio di Apollo, fece una palla di pelle di pollo. Tutti i pesci vennero a galla, per vedere la palla di pelle di pollo fatta da Apelle, figlio di Apollo.").
The switch #1 is initializing the communication process
The switch #2 is routing the message "Apelle,"
The switch #3 is routing the message "figlio"
The switch #4 is routing the message "di"
The switch #5 is routing the message "Apollo,"
The switch #6 is routing the message "fece"
The switch #7 is routing the message "una"
The switch #8 is routing the message "palla"
The switch #9 is routing the message "di"
The switch #10 is routing the message "pelle"
The switch #11 is routing the message "di"
The switch #12 is routing the message "pollo."
The switch #13 is routing the message "Tutti"
The switch #14 is routing the message "i"
The switch #15 is routing the message "pesci"
The switch #16 is routing the message "vennero"
The switch #17 is routing the message "a"
The switch #18 is routing the message "galla,"
The switch #19 is routing the message "per"
The switch #20 is routing the message "vedere"
The switch #1 is routing the message "la"
The switch #2 is routing the message "palla"
The switch #3 is routing the message "di"
The switch #4 is routing the message "pelle"
The switch #5 is routing the message "di"
The switch #6 is routing the message "pollo"
The switch #7 is routing the message "fatta"
The switch #8 is routing the message "da"
The switch #9 is routing the message "Apelle,"
The switch #10 is routing the message "figlio"
The switch #13 is finishing the communication process
The switch #12 is routing the message "Apollo."
The switch #11 is routing the message "di"
(amora@jarnbjorn)7> sender:shutdown(sif@jarnbjorn).
I'm closing ...
The switch #1 is gracely exiting
The switch #5 is gracely exiting
The switch #7 is gracely exiting
The switch #6 is gracely exiting
The switch #4 is gracely exiting
The switch #9 is gracely exiting
The switch #11 is gracely exiting
The switch #10 is gracely exiting
The switch #13 is gracely exiting
The switch #15 is gracely exiting
The switch #14 is gracely exiting
The switch #17 is gracely exiting
The switch #20 is gracely exiting
The switch #19 is gracely exiting
The switch #18 is gracely exiting
The switch #16 is gracely exiting
The switch #12 is gracely exiting
The switch #8 is gracely exiting
The switch #3 is gracely exiting
The switch #2 is gracely exiting
```


## Trace (receiver)
 
```
[21:58]cazzola@jarnbjorn:~/lp/erlang>erl -sname sif
(sif@jarnbjorn)1> receiver:start().
The message #0 is "Sopra la panca la capra canta!!! Sotto la panca la capra crepa!!!"
The message #0 is "Trentatre Trentini entrarono a Trento tutti e trentatre trotterellando!...
The message #1 is "Apelle, figlio di Apollo, fece una palla di pelle di pollo. Tutti i pes...
The receiver is gracely exiting
```
 
**All the solutions not conform to the specification will be considered wrong.**

