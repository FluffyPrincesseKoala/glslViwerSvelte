<script>
  import { onMount } from "svelte";
  import * as THREE from "three";

  import { OrbitControls } from "three/examples/jsm/controls/OrbitControls.js";
  import Stats from "three/examples/jsm/libs/stats.module.js";

  // import fragment from "./shader/a_base.frag.glsl";
  import fragment from "./shader/a_fractal.glsl";
  // import vertex from "./shader/a_base.vert.glsl";
  import vertex from "./shader/a_vertex.glsl";
  import { normalize } from "three/examples/jsm/nodes/Nodes.js";

  let camera, renderer;
  let canvas;

  onMount(() => {
    const resize = (camera, renderer) => {
      camera.aspect = window.innerWidth / window.innerHeight;
      camera.updateProjectionMatrix();
      renderer.setSize(window.innerWidth, window.innerHeight);
    };
    const scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera(
      75,
      window.innerWidth / window.innerHeight,
      1,
      1000,
    );
    const renderer = new THREE.WebGLRenderer({
      canvas: canvas,
      antialias: true,
    });

    // add background color
    renderer.setClearColor(0x2d2b55, 1);

    renderer.setSize(window.innerWidth, window.innerHeight);
    camera.position.z = 61;

    const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
    scene.add(ambientLight);

    const clock = new THREE.Clock();
    const uniforms = {
      resolution: { value: { x: null, y: null } },
      time: { value: 0.0 },
      u_mouse: { value: { x: null, y: null } },
      viewMatrix: { value: camera.matrixWorldInverse },
      cameraPositionX: { value: 0.0 },
      cameraPositionY: { value: 0.0 },
      cameraPositionZ: { value: 0.0 },
    };

    if (uniforms.resolution !== undefined) {
      uniforms.resolution.value.x = window.innerWidth;
      uniforms.resolution.value.y = window.innerHeight;
    }
    document.onmousemove = function (e) {
      uniforms.u_mouse.value.x = e.pageX;
      uniforms.u_mouse.value.y = e.pageY;
    };

    const axesHelper = new THREE.AxesHelper();

    const geometry = new THREE.BoxGeometry(16, 16, 16, 16, 16, 16);
    // Compute center and rotation for each face of the cube

    if (uniforms.u_rotation !== undefined) {
      uniforms.u_rotation.value.x = geometry.parameters.width;
      uniforms.u_rotation.value.y = geometry.parameters.height;
    }

    const material = new THREE.ShaderMaterial({
      uniforms: uniforms,
      vertexShader: vertex,
      fragmentShader: fragment,
    });

    // add a plane under the cube
    const planeGeometry = new THREE.PlaneGeometry(32, 32, 32, 32);

    const plane = new THREE.Mesh(planeGeometry, material);

    // Assuming planeWidth and planeHeight are both 32
    const planeSize = 32;

    // Calculate scale factors for width and height
    const scaleX = window.innerWidth / 10 / planeSize;
    const scaleY = window.innerHeight / 10 / planeSize;
    plane.scale.set(scaleX, scaleY, 1);
    scene.add(plane);

    const controls = new OrbitControls(camera, renderer.domElement);

    const stats = Stats();
    document.body.appendChild(stats.dom);

    const animate = () => {
      requestAnimationFrame(animate);

      const t = clock.getElapsedTime();
      uniforms.time.value = t;

      // Update the viewMatrix uniform
      material.uniforms.viewMatrix.value = camera.matrixWorldInverse;

      stats.update();
      // controls.update();

      renderer.render(scene, camera);
    };
    animate();

    window.addEventListener("resize", () => resize(camera, renderer));
  });
</script>

<div class="viewPort">
  <canvas bind:this={canvas} />
</div>

<style>
  .viewPort {
    display: flex;
  }
  canvas {
  }
</style>
