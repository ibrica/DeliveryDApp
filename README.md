# Package delivery ĐAPP

Simple ethereum blockchain app simulating package delivery service.

## Installation

Install Truffle globally.
    ```javascript
    npm install -g truffle
    ```

Download the box. This also takes care of installing the necessary dependencies.
    ```javascript
    truffle unbox webpack
    ```

Compile and migrate the smart contracts. Default setup is for local network (e.g. [testrpc](https://www.npmjs.com/package/ethereumjs-testrpc)) to change edit truffle.js.
    ```javascript
    truffle compile
    truffle migrate
    ```

Run the webpack server for front-end hot reloading.
    ```javascript
    // Serves the front-end on http://localhost:8080
    npm run dev
    ```

Run tests.
  ```javascript
  truffle test
  ```
