React = require 'react'
ReactDOM = require 'react-dom'
AppView = React.createFactory require('./demo/AppView')

ReactDOM.render(AppView(), document.getElementById('root'))
