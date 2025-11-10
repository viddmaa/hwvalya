using System;

class Program
{
    static void Main(string[] args)
    {
        var pipeline = new ScoringPipeline();
        
        // 1 заказ - все обработчики
        var context1 = new ScoreContext 
        { 
            ItemsCount = 3, 
            IsFirstPurchase = true, 
            HasReferral = true,
            TotalScore = 0
        };
        
        Console.WriteLine("\nДобавляем все обработчики");
        pipeline.Rules += ScoringRules.FirstPurchaseBonus;
        pipeline.Rules += ScoringRules.ReferralBonus;
        pipeline.Rules += (ctx) => { ctx.TotalScore += ctx.ItemsCount * 5; };
        
        pipeline.Run(context1);
        Console.WriteLine($"Результат с 3 обработчиками: {context1.TotalScore}");
        
        // 2 заказ - удален один обработчик
        var context2 = new ScoreContext 
        { 
            ItemsCount = 3, 
            IsFirstPurchase = true, 
            HasReferral = true,
            TotalScore = 0
        };
        
        Console.WriteLine("\nУдаляем FirstPurchaseBonus");
        pipeline.Rules -= ScoringRules.FirstPurchaseBonus;
        
        pipeline.Run(context2);
        Console.WriteLine($"Результат после удаления: {context2.TotalScore}");
    }
}