locals(
  foo: [{bar: "baz"}]
)

output("qux",
  value: '${local.foo[0]["bar"]}'
)
