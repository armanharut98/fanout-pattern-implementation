exports.handler = async (event) => {
    console.log("Marketing Lambda triggered!")
    console.log(`Message: ${JSON.stringify(event)}`)
    return event
}