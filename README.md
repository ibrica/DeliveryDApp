# Package delivery ĐAPP

Simple ethereum blockchain app simulating package delivery service.

## Installation
Download and install packages.
```
> npm install
```

Install Truffle globally.
```
> npm install -g truffle
```

Download the box. This also takes care of installing the necessary dependencies.
```
> unbox webpack
```

Compile and migrate the smart contracts. Default setup is for local network (e.g. [testrpc](https://www.npmjs.com/package/ethereumjs-testrpc)) to change edit truffle.js.
```
> truffle compile
> truffle migrate
```

Run the webpack server for front-end hot reloading.
```
// Serves the front-end on http://localhost:8080
> npm run dev
```

Run tests.
```
> truffle test
```
