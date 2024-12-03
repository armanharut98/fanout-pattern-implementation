exports.handler = async (event) => {
    console.log("Analytics Lambda triggered!")
    console.log(`Message: ${JSON.stringify(event)}`)
    return event
}