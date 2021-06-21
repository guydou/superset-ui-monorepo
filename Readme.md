## Superset dockerized viz plugin

When developing a custom viz plugin or fixing an existing plugin I recommend following [this](https://superset.apache.org/docs/installation/building-custom-viz-plugins) tutorial.

After developing the plugin you will probably want to deploy to production. 

In this repo I suggest a way to build a docker image with the changes. 

### Project structure 
1. `Dokerfile` 
1. `superset-ui` - my fork of superset-ui. Currently, it sets the max bar width of the echarts bar chart, It is still WIP, (that is why no PR)
1. `superset-frontend-override` - a folder container the files I will override in the `superset-frontend`. Currently, it overrides the package.json but later it will probably override also `superset/superset-frontend/src/visualizations/presets/MainPreset.js`


### Limitations
This `Dockerfile` uses version `1.1.0` but updating to another version should be easy

### Build
```bash
docker build --tag=custome/superset-node:1.1.0 ./
```