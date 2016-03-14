# Yun UI Kit

This library favors:

* **only supporting "all-green" browsers**<br>
over *messy code for backwards compatability*

* **functional implementations using the ramdajs library**<br>
over *imparative code*

* **minimal implementations for components supporting the most common use cases**<br>
over *an ocean of component properties*

* **composition through render callbacks**<br>
over *properties to tell components how to render themselves*

```
# NO
AmazingComponent {showBullets: true, height: 10, propertyToUse:'name'}

# YES
AmazingComponent
  renderItem: (item) ->
    div {style: {height:10}},
      span {}, \'*\'
      span {}, item.name


# NOTE: react-hot-loader does not support render callbacks yet.
# Because of this a workaround approach is used instead:
MyComponent = React.createClass
  render: ->
    {style, item} = @props
    div {style},
      span {}, \'*\'
      span {}, item.name

AmazingComponent
  itemComponent: MyComponent
  itemProps: {style: {height:10}}
```

# Inline styles
Also, right now this library is trying out inline styles. So for example, instead of specifying what children should look like:

```
.popup > ul { ... }
.content-box ul { ... }
.panel .list { ... }
```

...which is hard to override later. Inline styles gives a less cascading, more modular way of working.
If this is the best solution or if something like css-modules will win is left to see though :)




# TODO
 - [ ] switch port from 300 which might be coliding causing hot reloading to fail


