inputStyle =
	fontSize: '0.95em'
	width: 200
	padding: '5px'
	border: '1px solid #ccc'
	color: '#555555'
	outline: 'none'
	boxShadow: 'inset 0 1px 1px rgba(0, 0, 0, 0.075)'
	transition: 'all ease-in-out 0.15s'
	':focus':
		border: '1px solid #66AFE9'
		boxShadow: '0 0 2px #007FBB'

popupStyle =
	backgroundColor: '#fff'
	border: '1px solid #ddd'
	boxShadow: '0 1px 2px rgba(0, 0, 0, 0.1)'
	width: 200
	cursor: 'pointer'

sidebarStyle =
	backgroundColor: '#EDEDE5'


module.exports = {inputStyle, popupStyle, sidebarStyle}
