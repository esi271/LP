# Exercise Erlang (Odd): A Pass-Through Architecture for Palindromicity Test

This exercise asks for a specific architecture that we will name *pass-through architecture*, where a client and a server on separate Erlang nodes are connected through two other Erlang nodes that play the role of middlemen as in the picture below.

```
            +------+
      +---->|  M1  |----+
      |     +------+    |
      |                 v
  +--------+        +--------+
  | client |        | server |
  +--------+        +--------+
      |                 ^
      |     +------+    |
      +---->|  M2  |----+
            +------+
```

In this architecture, the messages from the client to the server pass through either the first or the second middleman. The middlemen just pass the messages from the client to the server.

You are asked to implement three separate modules `client`, `mm`, and `server`, each one devoted to implementing the corresponding component of the proposed architecture. Beyond that, the `client` module **has to** implement the functions `start/0` and `close/0` that have to bootstrap the whole system and to gracefully shut it down when called. Note that the `start/0` function will spawn both the middlemen and the server on their respective Erlang nodes and connect the actors to communicate as expected in the proposed architecture: **no other way of creating the actors on their respective node will be considered correct.** Each actor has to print messages to show they are working as expected and these messages **must** appear on their own shell. The names used by the four Erlang nodes **must** be `client`, `mm1`, `mm2`, and `server` respectively. **You are recommended to use the messages you see in the example.**

To demonstrate the correct implementation of your architecture, you are asked to implement a simple function, `is_palindrome/1`, to verify that a passed data is palindrome. The `is_palindrome/1` function splits its input in two so that each half has the same number of elements. The first element of the second half and the last one of the first half must coincide when the length of the passed data is odd. The two halves are sent to the first and the second middleman respectively one element at a time (to be clear the first half to the first middleman and the second half to the second middleman). The second half is sent to the middleman in the reverse order. The server must receive the data from the middlemen and compare them a couple at a time (one element received from the first middleman the second one from the second middleman) to determine if they are the same or not. It prints the message about the final result once all the couples have been compared. Note that the order is relevant to provide the correct result.