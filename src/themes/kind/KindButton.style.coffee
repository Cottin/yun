{all, none} = require 'ramda' #auto_require:ramda

base = 
	backgroundColor: '#fff'
	borderRadius: 3
	transition: 'all 0.1s ease-in'
	userSelect: 'none'
	cursor: 'pointer'
	padding: '5 0'
	display: 'inline-block'
	textAlign: 'center'

a =
	border: '1px solid #cdcdcd'
	color: '#049cdb'
	':hover':
		backgroundColor: '#049cdb'
		border: '1px solid #049cdb'
		color: '#fff'

c =
	border: '1px solid #cdcdcd'
	color: '#999999'
	':hover':
		backgroundColor: '#e6e6e6'
		color: '#555555'

leftMost =
	borderTopRightRadius: 0
	borderBottomRightRadius: 0
	borderRight: 'none'

middle =
	borderRadius: 0
	borderRight: 'none'

rightMost =
	borderTopLeftRadius: 0
	borderBottomLeftRadius: 0

selected =
	backgroundColor: '#464646'
	color: '#fff'
	borderColor: '#464646'
	':hover': {}

module.exports = {base, a, c, leftMost, middle, rightMost, selected}
