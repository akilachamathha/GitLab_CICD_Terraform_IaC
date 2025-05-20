const {
  ECSClient,
  DescribeServicesCommand,
  DescribeTaskDefinitionCommand,
  RegisterTaskDefinitionCommand,
  UpdateServiceCommand,
} = require("@aws-sdk/client-ecs");

const ecs = new ECSClient({ region: process.env.AWS_REGION });

const ECS_CLUSTER = process.env.ECS_CLUSTER;
const ECS_SERVICE = process.env.ECS_SERVICE;

exports.handler = async (event, context) => {
  console.log("Event: ", event);
  console.log("Context: ", context);
  try {
    // 1. Describe the current ECS service
    const serviceData = await ecs.send(
      new DescribeServicesCommand({
        cluster: ECS_CLUSTER,
        services: [ECS_SERVICE],
      })
    );

    const taskDefinitionArn = serviceData.services[0].taskDefinition;

    // 2. Get the current task definition
    const taskDefData = await ecs.send(
      new DescribeTaskDefinitionCommand({
        taskDefinition: taskDefinitionArn,
      })
    );

    const currentCpu = parseInt(taskDefData.taskDefinition.cpu);
    const currentMemory = parseInt(taskDefData.taskDefinition.memory);

    const containerDef = taskDefData.taskDefinition.containerDefinitions[0];

    // 3. Decrease the CPU and memory
    const newCpu = Math.max(256, Math.floor(currentCpu / 2)).toString(); // Min vCPU = 0.25
    const newMemory = Math.max(512, Math.floor(currentMemory / 2)).toString(); // Min Memory = 512 MB

    // 4. Register new task definition
    const newTaskDef = await ecs.send(
      new RegisterTaskDefinitionCommand({
        family: taskDefData.taskDefinition.family,
        requiresCompatibilities: ["FARGATE"],
        networkMode: "awsvpc",
        cpu: newCpu,
        memory: newMemory,
        executionRoleArn: taskDefData.taskDefinition.executionRoleArn,
        containerDefinitions: [
          {
            name: containerDef.name,
            image: containerDef.image,
            portMappings: containerDef.portMappings,
            essential: true,
          },
        ],
      })
    );

    const newTaskDefinitionArn = newTaskDef.taskDefinition.taskDefinitionArn;

    // 5. Update the ECS service
    await ecs.send(
      new UpdateServiceCommand({
        cluster: ECS_CLUSTER,
        service: ECS_SERVICE,
        taskDefinition: newTaskDefinitionArn,
      })
    );

    const message = `Scaled vertically Down to CPU: ${newCpu}, Memory: ${newMemory}`;
    console.log(message);
    return {
      statusCode: 200,
      body: JSON.stringify(message),
    };
  } catch (err) {
    console.error("Error scaling service:", err);
    return {
      statusCode: 500,
      body: JSON.stringify("Error occurred during vertical scaling"),
    };
  }
};
