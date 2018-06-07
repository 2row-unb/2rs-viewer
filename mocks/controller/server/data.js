module.exports = () => {
  const data = {
    athlete_model: {
      ok: true,
      thigh: {
        x: 50,
        y: 50
      },
      leg: {
        x: 70,
        y: 50
      }
    },
    ideal_model: {
      thigh: {
        x: 50,
        y: 50
      },
      leg: {
        x: 70,
        y: 50
      }
    },
    power: {
      ok: true,
      power: 400
    },
    speed: {
      ok: true,
      speed: 33
    },
    timer: {
      ok: true,
      timer: 122
    },
    difficulty: {
      ok: true,
      more: true,
      difficulty: 1,
      less: true
    },
    status: {
      ok: true,
      errors: []
    },
    state: {
      ok: true,
      state: 3
    },
    result: {
      ok: true,
      power: 167,
      speed: 33,
      timer: 2401,
      difficulty: 1.2,
      performance: 72,
      qrcode: "https://raw.githubusercontent.com/2row-unb/2rs-viewer/master/mocks/controller/server/qrcode.png"
    }
  }
  return data
}
