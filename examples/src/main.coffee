React = require 'react'
ReactDOM = require 'react-dom'
AppView = React.createFactory require('./AppView')

ReactDOM.render(AppView(), document.getElementById('root'))
