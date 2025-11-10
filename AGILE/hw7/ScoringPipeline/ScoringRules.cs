using System;

public static class ScoringRules
{
    public static void FirstPurchaseBonus(ScoreContext context)
    {
        if (context.IsFirstPurchase)
        {
            context.TotalScore += 10;
        }
    }

    public static void ReferralBonus(ScoreContext context)
    {
        if (context.HasReferral)
        {
            context.TotalScore += 20;
        }
    }
}