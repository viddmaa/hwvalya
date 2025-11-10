using System;

public class ScoringPipeline
{
    public RuleHandler? Rules { get; set; }
    
    public void Run(ScoreContext context)
    {
        Rules?.Invoke(context);
    }
}