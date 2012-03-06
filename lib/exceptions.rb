module Agent
  class AgentException < Exception ; end

  class ActionNotUnderstood < AgentException ; end

  class NoImplementationGiven < AgentException ; end
end
