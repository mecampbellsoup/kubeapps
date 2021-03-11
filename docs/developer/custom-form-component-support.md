# Custom Form Component Support
This is an extension to the [basic form support](https://github.com/kubeapps/kubeapps/blob/master/docs/developer/basic-form-support.md#basic-form-support)

## Possible use cases
- Custom UI component that are not yet supported by the basic components (e.g: radio selectors)
- Consuming third party APIs for component values and validation

## Adding a bundle
The js bundles are loaded as a configMap and its value can be set in the `values.yaml` file. By setting the path to the bundle in the `values.yaml` we are able to leverage the [Helm .Files object](https://helm.sh/docs/chart_template_guide/accessing_files/#glob-patterns) to load the bundle into the configMap. For example:
```
  customComponents: "js/custom_components.js"
```
In this example Helm will look in the `js` directory relative to the `values.yaml` 

## Render a custom component
Signaling to the Kubeapps dashboard that you want to render a custom component is pretty straight forward.  Simply add a `customComponent` field to any form parameter defined in the  `values.json.schema` and that will tell the react application to fetch the component from the custom js bundle. An example parameter could look like:
```
    "databaseType": {
      "type": "string",
      "form": true,
      "enum": ["mariadb", "postgresql"],
      "title": "Database Type",
      "description": "Allowed values: \"mariadb\" and \"postgresql\"",
      "customComponent": {
          "type": "radio",
          "className": "primary-radio"
      }
    }
```
Note: The `customComponent` field **MUST BE AN OBJECT**. This design decision was made so that developers can pass extra values/properties into their custom components should they require them.

## Updating values with custom components
Custom form components would be useless without the ability to interact with the YAML state. To do this your custom components should be set up to receive 2 props: `handleBasicFormParamChange` and `param`. `param` is the current json object this is being rendered (denoted by the `customComponent` field) and `handleBasicFormParamChange` which is a function that updates the YAML file. An example of how you use this function can be found in any of the BasicDeploymentForm components such as the [SliderParam](https://github.com/kubeapps/kubeapps/blob/master/dashboard/src/components/DeploymentFormBody/BasicDeploymentForm/SliderParam.tsx#L47-L53).
```
  const handleParamChange = (newValue: number) => {
    handleBasicFormParamChange(param)({
      currentTarget: {
        value: newValue,
      },
    } as React.FormEvent<HTMLInputElement>);
  };
```

## Tips
To try this feature out we offer a pre-minified, bundled react component that you can try out! Note: It does not do much, its a simple button that will set the value of whatever param you render the custom component into as `test`. But it will help you understand how to integrate custom components. That file can be found [here](https://github.com/kubeapps/kubeapps/blob/master/docs/developer/fixtures/custom_components.js). The bundled custom component was created using [remote-component-starter](https://github.com/Paciolan/remote-component-starter), which is specifically made to help build components that you want to load remotely with the [remote-component](https://github.com/Paciolan/remote-component) tool used by Kubeapps.