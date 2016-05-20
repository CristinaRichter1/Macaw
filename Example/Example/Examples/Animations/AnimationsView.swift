import UIKit
import Macaw

class AnimationsView: MacawView {

	var animations = [TransformAnimation]()
	var ballNodes = [Group]()

	let n = 150
	let speed = 10.0
	let startPoint = Point(x: 150.0, y: 150.0)
	let r = 10.0

	required init?(coder aDecoder: NSCoder) {

		for _ in 0 ... (n - 1) {
			let circle = Circle(cx: startPoint.x, cy: startPoint.y, r: r)
			let shape = Shape(
				form: circle,
				fill: [Color.red, Color.green, Color.blue, Color.yellow, Color.olive, Color.purple][Int(rand() % 6)]
			)

			let ballGroup = Group(contents: [shape], pos: Transform())

			ballNodes.append(ballGroup)
		}

		let node = Group(contents: ballNodes,
			pos: Transform().move(0.0, my: 0.0))

		super.init(node: node, coder: aDecoder)
	}

	required init?(node: Node, coder aDecoder: NSCoder) {
		super.init(node: node, coder: aDecoder)
	}

	func startAnimation() {

		prepareAnimation()

		animations.forEach { animation in
			super.addAnimation(animation)
		}
	}

	private func prepareAnimation() {

		var velocities = [Point]()
		var positions = [Point]()

		func posForTime(t: Double, index: Int) -> Point {

			let prevPos = positions[index]
			var velocity = velocities[index]

			var pos = prevPos.add(velocity)
			let scenePos = pos.add(startPoint)

			// Borders
			if scenePos.x < 0.0 || scenePos.x > Double(self.bounds.width) {
				velocity = Point(x: -1.0 * velocity.x, y: velocity.y)
				velocities[index] = velocity
				pos = prevPos.add(velocity)
			}

			if scenePos.y < 0.0 || scenePos.y > Double(self.bounds.height) {
				velocity = Point(x: velocity.x, y: -1.0 * velocity.y)
				velocities[index] = velocity
				pos = prevPos.add(velocity)
			}

			return pos
		}

		for i in 0 ... (n - 1) {
			let velocity = Point(
				x: -0.5 * speed + speed * Double(rand() % 1000) / 1000.0,
				y: -0.5 * speed + speed * Double(rand() % 1000) / 1000.0)
			velocities.append(velocity)
			positions.append(Point(x: 0.0, y: 0.0))

			let ballGroup = ballNodes[i]
			let animation = TransformAnimation(animatedShape: ballGroup, observableValue: ballGroup.posVar, valueFunc: { t -> Transform in

				let pos = posForTime(t, index: i)
				positions[i] = pos

				return Transform().move(
					pos.x,
					my: pos.y)
				}, animationDuration: 20.0)

			animation.autoreverses = true

			animations.append(animation)
		}
	}
}
