import numpy as np

p1_payoffs = np.array([[3, 0], [5, 1]])
p2_payoffs = np.array([[3, 5], [0, 1]])
game = np.array([
    p1_payoffs,
    p2_payoffs
])

print(game[0][0])


rewards = np.array([3, 0, 5, 1]) # starting top left, going clockwise
actions = np.array(["coop", "defect"])

class PHC:
    def __init__(self, actions, rewards, alpha=0.5, gamma=0.9, lr=0.01, epsilon=0.8):
        self.id = 0
        self.actions = np.arange(len(actions)).astype(int)
        self.rewards = rewards
        self.Q = np.zeros(self.actions.shape)
        self.policy = np.full(self.actions.shape, 1/self.actions.size)
        self.alpha = alpha
        self.gamma = gamma
        self.epsilon = epsilon
        self.lr = lr

    def maxQ(self):
        return np.argmax(self.Q)

    def observe(self, actions, rewards):
        reward = rewards[self.id]
        action = actions[self.id]
        next_action = self.maxQ()
        a = self.alpha
        g = self.gamma
        Q = self.Q
        Q[action] = ((1-a) * Q[action]) + (a * (reward + (g * Q[next_action])))

        # update policy and constrain to a legal probability distribution
        for a in range(len(self.policy)):
            if a == next_action:
                self.policy[a] += self.lr
            else:
                self.policy[a] += -(self.lr) / (self.actions.size -1)

    def play(self):
        if np.random.sample() < self.epsilon:
            return np.random.choice(self.actions, p=self.policy)
        else:
            return np.random.choice(self.actions)


class WOLF_PHC:
    def __init__(self, actions, rewards, alpha=0.5, gamma=0.9, lr=0.01,
            delta_win=0.01, delta_lose=0.02, epsilon=0.7):
        self.id = 0
        # self.actions = np.zeros(len(actions)).astype(int)

        # TODO:
        # this simply creates an array [0, 1]
        self.actions = np.arange(len(actions)).astype(int)

        self.count = 0
        self.rewards = rewards
        self.Q = np.zeros(self.actions.shape)
        self.policy = np.full(self.actions.shape, 1/self.actions.size)
        self.avg_policy = np.zeros_like(self.policy)
        self.alpha = alpha
        self.gamma = gamma
        self.lr = lr
        self.delta_win = delta_win
        self.delta_lose = delta_lose

        #TODO:
        # need this to induce random exploration
        self.epsilon = epsilon

    def maxQ(self):
        return np.argmax(self.Q)

    def observe(self, actions, rewards):
        reward = rewards[self.id]
        action = actions[self.id]
        next_action = self.maxQ()
        a = self.alpha
        g = self.gamma
        Q = self.Q
        Q[action] = ((1-a) * Q[action]) + (a * (reward + (g * Q[next_action])))

        # update estimate of average policy
        self.count += 1
        for a in range(len(self.avg_policy)):
            self.avg_policy[a] += ((self.policy[a] - self.avg_policy[a]) / self.count)

        # update policy and constrain to a legal probability distribution
        if np.dot(self.policy, Q) > np.dot(self.avg_policy, Q):
            delta = self.delta_win
        else:
            delta = self.delta_lose

        for a in range(len(self.policy)):
            if a == next_action:
                self.policy[a] = min(1, self.policy[a] + delta)
            else:
                self.policy[a] = max(0, (self.policy[a] - ((delta) / (self.actions.size -1))))

    def play(self):

        # TODO:
        # we need to either choose our action according to the policy distribution
        # or explore randomly

        if np.random.sample() < self.epsilon:
            return np.random.choice(self.actions, p=self.policy)
        else:
            return np.random.choice(self.actions)

phc = WOLF_PHC(actions, rewards)
print(phc.actions)
print(phc.rewards)
print(phc.Q)
print(phc.policy)

while True:
    action = phc.play()
    print(action)
    opp = int(input())
    actions = [0, 0]
    actions[0] = action
    actions[1] = opp
    rewards = [0, 0]
    rewards[0] = game[0][action][opp]
    rewards[1] = game[0][opp][action]
    print("actions: ", actions)
    print("rewards: ", rewards)
    print("Q: ", phc.Q)
    print("policy: ", phc.policy)
    phc.observe(actions, rewards)
    print("updated Q: ", phc.Q)
    print("updated policy: ", phc.policy)
