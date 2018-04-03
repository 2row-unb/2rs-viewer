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
    heartbeat: {
      ok: true,
      heartbeat: 100
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
    }
  }
  return data
}
