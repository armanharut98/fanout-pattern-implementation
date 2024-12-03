exports.handler = async (event) => {
    console.log("Marketing Lambda triggered!")
    const message = event.records[0].body.message
    console.log(`Message: ${message}`)
    return event
}