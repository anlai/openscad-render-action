# OpenSCAD Compile & Render GitHub Action

This github action will "compile" your scad file (and any imports) into a single file which can be used with online scad editors like found on Makerworld.  The action will then render stl files based on configurations defined in the customizer json parameters file.

*Note:* if referencing external libraries, ensure those are cloned and in a relative path referenced in your scad file.

## Inputs

| name | required | description |
| --- | --- | --- |
| scad-file | yes | relative path in the repository to the scad file |
| tag | no | version number tag <br/> default value: `{year}{month}{day}-{hour}` |
| openscad-version | no | Version of OpenSCAD to use, see tags available at [DockerHub-OpensCAD](https://hub.docker.com/r/openscad/openscad) <br/>default value: `latest` |

## Ouputs

Compiled and rendered files are all placed into the `/output` folder.

Compiled scad file name format: `{scad file name}-{tag}.scad`

Rendered STL file name format: `{scad file name}-{tag}-{customizer setting name}.stl`

## Usage

Basic example.

```YAML
- name: compiled and render
    uses: anlai/openscad-render-action@v1
    with:
        scad-file: design-file.scad
```

This example defines which version of OpenSCAD to use.

```YAML
- name: compiled and render
    uses: anlai/openscad-render-action@v1
    with:
        scad-file: design-file.scad
        tag: 'v1.0.0'
        openscad-version: 'dev.2025-02-17'
```