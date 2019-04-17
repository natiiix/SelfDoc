using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace SelfDoc
{
    public class Program
    {
        private static Dictionary<string, double> variables = new Dictionary<string, double>();

        private static void Main(string[] args)
        {
            string command = string.Empty;

            while (!string.IsNullOrWhiteSpace(command = Prompt()))
            {
                Match match = null;

                if ((match = Regex.Match(command, @"^let (\w+) be (.+)$")).Success)
                {
                    variables[match.Groups[1].Value] = Evaluate(match.Groups[2].Value);
                }
                else if ((match = Regex.Match(command, @"^print (.+)$")).Success)
                {
                    Console.WriteLine($"{match.Groups[1].Value} = {Evaluate(match.Groups[1].Value)}");
                }
            }
        }

        private static double Evaluate(string str)
        {
            Match match = null;

            if (variables.ContainsKey(str))
            {
                return variables[str];
            }
            else if (double.TryParse(str, out double value))
            {
                return value;
            }
            else if ((match = Regex.Match(str, @"^sum of (.+?) and (.+)$")).Success)
            {
                return Evaluate(match.Groups[1].Value) + Evaluate(match.Groups[1].Value);
            }

            throw new ArgumentException("Unable to evaluate: " + str);
        }

        private static string Prompt()
        {
            Console.Write(">");
            return Console.ReadLine();
        }
    }
}
